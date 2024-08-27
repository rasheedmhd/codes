use pigment::run::start;
use std::net::TcpListener;

#[tokio::main]
async fn main() -> Result<(), std::io::Error> {
    let tcp_listener = TcpListener::bind("127.0.0.1:0")?;
    start(tcp_listener)?.await
}
