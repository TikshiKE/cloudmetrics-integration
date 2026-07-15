"""Generate scripts/snowflake/04_load_csv_data.sql from data/*.csv."""
import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"
OUT = ROOT / "scripts" / "snowflake" / "04_load_csv_data.sql"


def esc(value: str) -> str:
    return value.replace("'", "''")


def main() -> None:
    lines = [
        "-- Load HubSpot + Intercom CSV into RAW",
        "-- Run after 02_create_raw_tables.sql",
        "",
        "USE ROLE ACCOUNTADMIN;",
        "USE WAREHOUSE DEV_WH;",
        "USE DATABASE CLOUDMETRICS;",
        "USE SCHEMA RAW;",
        "",
        "TRUNCATE TABLE IF EXISTS HUBSPOT_CONTACTS;",
        "TRUNCATE TABLE IF EXISTS INTERCOM_CONVERSATIONS;",
        "",
    ]

    with open(DATA / "hubspot_contacts.csv", newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            lines.append(
                "INSERT INTO HUBSPOT_CONTACTS "
                "(contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ("
                f"'{esc(row['contact_id'])}', '{esc(row['email'])}', '{esc(row['company'])}', "
                f"'{esc(row['plan'])}', '{esc(row['lifecycle_stage'])}', {row['company_size']}, "
                f"'{row['updated_at']}'::TIMESTAMP_TZ);"
            )

    lines.append("")

    with open(DATA / "intercom_conversations.csv", newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            resolved = (
                f"'{row['resolved_at']}'::TIMESTAMP_TZ"
                if row["resolved_at"].strip()
                else "NULL"
            )
            lines.append(
                "INSERT INTO INTERCOM_CONVERSATIONS "
                "(conversation_id, contact_id, opened_at, resolved_at, status) VALUES ("
                f"'{esc(row['conversation_id'])}', '{esc(row['contact_id'])}', "
                f"'{row['opened_at']}'::TIMESTAMP_TZ, {resolved}, '{esc(row['status'])}');"
            )

    lines.extend(
        [
            "",
            "SELECT 'HUBSPOT_CONTACTS' AS t, COUNT(*) FROM HUBSPOT_CONTACTS",
            "UNION ALL",
            "SELECT 'INTERCOM_CONVERSATIONS', COUNT(*) FROM INTERCOM_CONVERSATIONS;",
        ]
    )

    OUT.write_text("\n".join(lines), encoding="utf-8")
    print(f"Wrote {OUT} ({len(lines)} lines)")


if __name__ == "__main__":
    main()
