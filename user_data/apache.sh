#!/bin/bash
dnf install -y httpd

systemctl enable httpd
systemctl start httpd

cat > /var/www/html/index.html <<EOF
<html>
  <head>
    <title>SRE Technical Challenge</title>
  </head>
  <body>
    <h1>SRE Technical Challenge</h1>
    <p>Apache is running on RHEL 9.</p>
    <p>Hostname: $(hostname)</p>
  </body>
</html>
EOF