# Dockerizing with NGINX

## Dockerfile Instructions

Since you have a `publish` folder containing your static files (including `index.html`), you can use the following Dockerfile to serve your Blazor WebAssembly application via NGINX.

### Dockerfile

```dockerfile
# Use NGINX as the base image
FROM nginx:alpine

# Copy the Blazor WebAssembly build files from 'publish' folder into the NGINX html directory
COPY ./publish /usr/share/nginx/html

# Expose port 38090
EXPOSE 38090

# Start NGINX in the foreground to keep the container running
CMD ["nginx", "-g", "daemon off;"]
```

### Step by step

1. **Base Image (`FROM nginx:alpine`)**: 
   - Uses the NGINX Alpine version as a lightweight web server to serve your static files.

2. **Copy Files**:
   - The `COPY ./publish /usr/share/nginx/html` command copies all the contents of the `publish` folder into the NGINX directory for static files (`/usr/share/nginx/html`). This ensures that NGINX will serve your `index.html` (or any other HTML files in the `publish` folder) as the web page.

3. **Expose Port**:
   - The `EXPOSE 38090` command makes port `38090` available on your local machine, which will be mapped to port `80` inside the container (default for NGINX).

4. **Run NGINX**:
   - The `CMD ["nginx", "-g", "daemon off;"]` ensures that NGINX will run in the foreground, which is necessary for the container to stay running.

## Steps to Build and Run the Docker Container

1. **Build the Docker Image**:
   
   Run the following command in your terminal to build the Docker image:

   ```bash
   docker build -t blazor-webassembly-nginx .
   ```

2. **Run the Docker Container**:

   Once the image is built, run the container with the following command:

   ```bash
   docker run -d -p 38090:80 --name blazor-app blazor-webassembly-nginx
   ```

   This command will map port `38090` on your local machine to port `80` on the container, where NGINX is serving the static files.

3. **Access the Application**:

   Now, you can access your Blazor WebAssembly app by visiting:

   ```
   http://localhost:38090
   ```

## Verifications

- **Directory Structure**: 
  - Make sure that the `index.html` file is inside the `publish` directory (or within subdirectories like `publish/wwwroot`).
  
  If the files are in a subfolder (e.g., `publish/wwwroot`), adjust the `COPY` command in the Dockerfile:

  ```dockerfile
  COPY ./publish/wwwroot /usr/share/nginx/html
  ```

- **Check if `index.html` is served**: 
  - After running the container, if you navigate to `http://localhost:38090`, you should see the app being served correctly.


With these steps, your Blazor WebAssembly app should be successfully containerized and served via NGINX locally on your local!
