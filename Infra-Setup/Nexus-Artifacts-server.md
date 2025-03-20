# Nexus Repository Manager Setup using Docker

## Overview
This guide provides step-by-step instructions for setting up a **Nexus Repository Manager** using Docker on any Linux-based server. It also includes instructions for accessing the Nexus UI and creating an artifact repository where the project's build artifacts can be uploaded.

---

## Prerequisites
**Ensure your server meets the following requirements:**
- A Linux-based operating system (Ubuntu recommended)
- Docker installed (if not already installed, the script below will handle it)
- Access to the internet for downloading the Nexus image

---

## Step 1: Setting Up Nexus Repository Manager
Run the following script to install Docker and deploy Nexus in a Docker container:

```bash
#!/bin/bash
sudo apt-get update

## Install Docker
yes | sudo apt-get install docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
sudo chmod 666 /var/run/docker.sock
echo "Waiting for 30 seconds before running Nexus Docker container..."
sleep 30

## Running Nexus in a Docker container
docker run -d -p 8081:8081 --name nexus-container sonatype/nexus3:latest
```

### Explanation of the Script:
- Updates the package list
- Installs Docker if not already installed
- Starts and enables the Docker service
- Adds the current user to the Docker group for permission management
- Adjusts permissions to allow non-root access to the Docker daemon
- Waits 30 seconds to ensure proper startup
- Pulls and runs the latest Nexus 3 repository manager container, mapping port 8081

---

## Step 2: Accessing the Nexus UI
Once the Nexus container is running, follow these steps to access the web UI:

1. Open your browser and navigate to:
   ```
   http://<server-ip>:8081
   ```
   (Replace `<server-ip>` with your actual server's IP address)
2. The default admin credentials are:
   - Username: `admin`
   - Password: Located inside the container. Run the following command to retrieve it:
     ```bash
     docker exec nexus-container cat /nexus-data/admin.password
     ```
3. Copy the password, log in, and change it as prompted.

---

## Step 3: Creating a Nexus Artifact Repository
To create an artifact repository where the project build artifacts will be uploaded:

### 1. Log in to Nexus Repository Manager
- Navigate to `http://<server-ip>:8081`
- Enter your admin credentials

### 2. Create a New Repository
1. Click on **Administration** in the left sidebar
2. Navigate to **Repositories**
3. Click **Create repository**
4. Select the repository type (e.g., `hosted` for storing build artifacts)
5. Configure the repository settings:
   - **Name:** test-reports
   - **Type:** `hosted`
   - **Version Policy:** Release or Snapshot (based on your requirement)
   - **Write Policy:** Allow (so that artifacts can be uploaded)
6. Click **Create Repository**

---

## Step 4: Uploading Artifacts to Nexus Repository
After setting up the repository, this section of the **[GitHub Actions workflow](https://github.com/Godfrey22152/Canary-Deployment-with-Argo-Rollout/blob/e0525d88e738d3355a9e7465929c9213cc1494b5/.github/workflows/canary-deployment-workflow.yml#L176)** script automates the upload of the artifacts to the Nexus Repository **`test-reports`** we created:

```yaml
- name: Upload Reports to Nexus Artifact Repository
  run: |
    find test-reports -type f | while read file; do
      # Construct the Nexus upload URL by replacing "test-reports/" with the target path
      target_path=$(echo "$file" | sed 's|test-reports/||')

      echo "Uploading $file to Nexus..."

      curl -u "${{ secrets.NEXUS_USERNAME }}:${{ secrets.NEXUS_PASSWORD }}" \
           --upload-file "$file" \
           "${{ secrets.NEXUS_URL }}/repository/test-reports/$target_path"
    done
```

### Explanation:
- Searches for all files in the `test-reports` directory
- Loops through each file and constructs a proper upload path
- Uses `curl` to upload each file to the Nexus repository using stored credentials

---

## Conclusion
By following these steps, you can create a fully functional Nexus Repository Manager running in a Docker container, a configured repository for storing artifacts, and an overview on how GitHub actions handles the automated way to upload build artifacts. Nexus provides a centralized and secure place for artifact management in the CI/CD pipelines.

