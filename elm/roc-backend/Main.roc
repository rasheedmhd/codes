# app [main] {
#    pf: platform "https://github.com/roc-lang/basic-webserver/releases/download/0.7.0/tE4xS_zLdmmxmHwHih9kHWQ7fsXtJr7W7h3425-eZFk.tar.br",
# }
# import pf.Stdout
# import pf.Task
# import pf.Http
# import pf.Tcp
# port : U16
# port = 8080
# main : Task.Task {} *
# main =
#    config = {
#        port,
#        host: "localhost",
#        onListen: \_ -> Stdout.line "Listening on http://localhost:$(Num.toStr port)",
#    }
#    Tcp.listen config handleRequest
# handleRequest : Http.Request -> Task.Task Http.Response *
# handleRequest = \req ->
#    response = {
#        status: 200,
#        headers: [("Content-Type", "text/html; charset=utf-8")],
#        body: "Hello from Roc! You requested: $(req.url)",
#    }
#    Task.ok response
app [main] {
    pf: platform "https://github.com/roc-lang/basic-webserver/releases/download/0.6.0/LQS_Avcf8ogi1SqwmnytRD4SMYiZ4UcRCZwmAjj1RNY.tar.gz",
}

import pf.Stdout
import pf.Task exposing [Task]
import pf.Http exposing [Request, Response]
import pf.Utc

main : Request -> Task Response []
main = \req ->

    # Log request date, method and url
    date = Utc.now! |> Utc.toIso8601Str
    Stdout.line! "$(date) $(Http.methodToStr req.method) $(req.url)"

    Task.ok { status: 200, headers: [], body: Str.toUtf8 "<b>Hello, world!</b>\n" }
