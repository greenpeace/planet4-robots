/* global addEventListener, Response */

addEventListener("fetch", event => {
  const data = "User-agent: *\nDisallow: /";

  return event.respondWith(
    new Response(data, {
      headers: {
        "content-type": "text/plain;charset=UTF-8"
      }
    })
  );
});
