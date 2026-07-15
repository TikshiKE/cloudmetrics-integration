from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    segment_write_key: str = ""
    app_env: str = "development"
    hubspot_mock_secret: str = ""
    port: int = 8080

    @property
    def segment_enabled(self) -> bool:
        return bool(self.segment_write_key.strip())


settings = Settings()
