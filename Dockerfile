FROM nginx:alpine

COPY . /usr/share/nginx/html

EXPOSE 38090

CMD ["nginx", "-g", "daemon off;"]
