import "@typespec/http";

using Http;

@service(#{ title: "Call Calendar API" })
namespace CallCalendar;

@route("/api/health")
@get
op getHealth(): { status: "ok" };
