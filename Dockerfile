# Nutzt Node als Base-Image in der "Builder"-Phase
FROM node:alpine as builder
WORKDIR /app
COPY package.json .
RUN npm install

# Der Kopierschritt ist hier, im Gegensatz zur dev-Version, zwingend notwendig!
COPY . .
RUN npm run build

# Eine zweite Phase beginnt mit der Nutzung eines neuen Base-Image. Hier nginx, ein Webserver für die Produktionsumgebung.
FROM nginx
# Kopiert die Build-Artefakte aus der ersten Phase in den nginx-Ordner
COPY --from=builder /app/build /usr/share/nginx/html

# Am Ende bleiben nur die Inhalte der letzten Phase übrig; die zuvor aufgesetzte Node-Umgebung wird platt gemacht.
# Der nginx-Server ist per default über Port 80 erreichbar

