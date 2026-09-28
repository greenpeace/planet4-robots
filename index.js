/* global addEventListener */

addEventListener("fetch", event => {
  const request = event.request;
  const url = new URL(request.url);

  if (url.pathname === "/favicon.ico") {
    event.respondWith((async () => {
      const imageResponse = await fetch("https://www.greenpeace.org/global/static/img/favicon.ico", {
        headers: {
          "User-Agent": request.headers.get("User-Agent") || "Cloudflare-Worker-Favicon-Proxy"
        }
      });
      const headers = new Headers(imageResponse.headers);
      headers.set("Content-Type", "image/x-icon");
      headers.set("Cache-Control", "public, max-age=86400, s-maxage=604800");

      return new Response(imageResponse.body, {
        status: 200,
        headers
      });
    })());
    return;
  }

  const allow_all = "User-agent: *\nDisallow:";
  const deny_all = "User-agent: *\nDisallow: /";
  const data = request.url.includes("www.greenpeace.org/robots.txt")
    ? allow_all
    : deny_all;

  event.respondWith(
    new Response(data, {
      headers: {
        "content-type": "text/plain;charset=UTF-8"
      }
    })
  );
});
