<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>PoC Tomcat</title>
</head>
<body>
  <h1>Works!</h1>
  <p>Tomcat is serving the WAR correctly.</p>
  <p>Pod: <%= java.net.InetAddress.getLocalHost().getHostName() %></p>
</body>
</html>
