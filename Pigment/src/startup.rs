use crate::routes::health_check::health_check;
use crate::routes::subscriptions::subscribe;
use actix_web::dev::Server;
use actix_web::{web, App, HttpServer};
use std::net::TcpListener;
use sqlx::PgConnection;

pub fn run(tcp_listener: TcpListener, connection: PgConnection) -> Result<Server, std::io::Error> {
    // Wrap the connection in a smart pointer
    let connection = web::Data::new(connection);
    // Capture `connection` from the surrounding environment
    let server = HttpServer::new(move|| {
        App::new()
            .route("/health_check", web::get().to(health_check))
            .route("/subscriptions", web::post().to(subscribe))
            // Register the db connection as part of the application state
            .app_data(connection.clone())
    })
    .listen(tcp_listener)?
    .run();

    Ok(server)
}