use actix_web::{HttpResponse, web};

#[derive(serde::Deserialize)]
struct FormData {
    email: String,
    name: String,
}

pub(crate) async fn subscribe(_form: web::Form<FormData>) -> HttpResponse {
    HttpResponse::Ok().finish()
}