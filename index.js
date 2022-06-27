/* global addEventListener, Response */

addEventListener("fetch", event => {
  let request = event.request;
  const allow_all = "User-agent: *\nDisallow:";
  const deny_all = "User-agent: *\nDisallow: /";
  let data = "";

  if (request.url.includes("www.greenpeace.org/robots.txt")) {
    data = allow_all;
  } else {
    data = deny_all;
  }

  return event.respondWith(
    new Response(data, {
      headers: {
        "content-type": "text/plain;charset=UTF-8"
      }
    })
  );
});
