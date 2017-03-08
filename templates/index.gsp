<%include "header.gsp"%>

	<%include "menu.gsp"%>

	<%published_posts.each {post ->%>
		<a href="${post.uri}"><h1>${post.title}</h1></a>
		<p>${post.date.format("dd MMMM yyyy")}</p>
		<p>${post.body.take(post.body.indexOf(config.post_summary_marker))}</p>
		<p><a href="${post.uri}">Read more</a></p>
  	<%}%>
	
	<hr />
	
	<p><a href="/${config.archive_file}">Post Archive</a></p>

<%include "footer.gsp"%>