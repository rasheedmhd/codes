use std::net::TcpListener;
use sqlx::{PgConnection, Connection};
use pigment::startup::run;
use pigment::configuration::get_configuration;

#[tokio::main]
async fn main() -> Result<(), std::io::Error> {
    let configuration = get_configuration().expect("Failed to read configuration.");
    let connection = PgConnection::connect(&configuration.database.connection_string())
        .await
        .expect("Failed to connect to Postgres.");
    let tcp_listener = TcpListener::bind("127.0.0.1:0")?;
    run(tcp_listener, connection)?.await
}