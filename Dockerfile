
FROM tomcat:9.0-jdk17

COPY target/mario-game.war /usr/local/tomcat/webapps/mario-game.war

EXPOSE 8080

CMD ["catalina.sh", "run"]

