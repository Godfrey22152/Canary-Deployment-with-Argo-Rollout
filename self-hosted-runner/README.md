# GitHub Actions Self-Hosted Runner Setup on Linux
This guide provides step-by-step instructions for setting up a self-hosted GitHub Actions runner on a Linux machine (Virtual machine) using **Vagrant** and **VirtualBox**. The Vagrantfile provisions an Ubuntu 22.04 environment with necessary tools such as **Python**, **Docker**, **Trivy**, **Bandit**, **Pytest**, and **Docker Scout CLI**.

## Prerequisites

1. A GitHub repository or organization where the runner will be registered.
2. A Linux-based server or virtual machine. 
   - Before starting, ensure you have the following installed on your host machine (If using Virtual machine):
       - [Vagrant](https://www.vagrantup.com/downloads)
       - [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
     
3. `curl`, `tar,` and `systemd` installed on the machine.

## Setting Up the Vagrant Environment

### Step 1: Create a New Directory

Create a new directory for your Vagrant environment and navigate into it:

```sh
mkdir self-hosted-agent
cd self-hosted-agent

```
### Step 2: Create the Vagrantfile
Create a Vagrantfile in the directory with the following content:

```sh
# Vagrantfile for an Ubuntu 22.04 self-hosted agent for Azure CI/CD pipeline
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  
  # Allocate 4GB of RAM
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
  end

  # Provisioning script
  config.vm.provision "shell", inline: <<-SHELL
    # Update and upgrade the system
    sudo apt-get update

    # Install Python and pip
    sudo apt-get install -y python3 python3-pip

    # Install Docker
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo chmod 666 /var/run/docker.sock

    # Install Trivy
    wget https://github.com/aquasecurity/trivy/releases/download/v0.27.1/trivy_0.27.1_Linux-64bit.deb
    sudo dpkg -i trivy_0.27.1_Linux-64bit.deb

    # Install Bandit
    pip install bandit
    
    # Install Pytest and Pytest-cov
    pip install pytest pytest-cov

    # Install Docker Scout CLI
    curl -sSfL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh | sh -s --
  SHELL
end

```
### Step 3: Start the Vagrant Environment
Run the following command to start the Vagrant environment:

```sh
vagrant up

```
This command will download the specified Ubuntu box, create a virtual machine, and run the provisioning script to install the necessary tools.

### Step 4: SSH into the Vagrant Machine
Once the setup is complete, SSH into the Vagrant machine:

```sh
vagrant ssh

```
You now have a self-hosted runner environment (Linux-server setup through Virtual machine and Vagrant) with all required tools installed.

---

## Configuring the Server for the GitHub Actions Runner

### Step 1: Create a Self-Hosted Runner in GitHub
1. Navigate to your GitHub repository.
2. Go to **Settings > Actions > Runners**.
3. Click **New self-hosted runner**.
4. Select **Linux** as the runner image.
5. Copy the provided setup commands.

### Step 2: Install and Configure the Runner
Run the following commands on your Linux machine:

```sh
# Create a directory for the runner
mkdir actions-runner && cd actions-runner

# Download the latest runner package
curl -o actions-runner-linux-x64-2.322.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.322.0/actions-runner-linux-x64-2.322.0.tar.gz

# Extract the runner package
tar xzf ./actions-runner-linux-x64-2.322.0.tar.gz

# Create the runner and start the configuration experience
./config.sh --url https://github.com/YOUR_GITHUB_REPO --token YOUR_RUNNER_TOKEN
```

Replace `YOUR_GITHUB_REPO` with your repository URL and `YOUR_RUNNER_TOKEN` with the token obtained from GitHub.

#### Configuration Steps:

1. When prompted, provide a name for the runner group to add the runner to (or press Enter to use the default).
2. When prompted, provide a name for the runner=`Any Name` (or press Enter to use the default).
3. When prompted to enter additional **Labels** for the runner, **(Press Enter to Skip)** as the runner will have the following Labels: `self-hosted`, `Linux`, `X64`.
4. Select a working directory where the runner will execute jobs (default is the current directory `_work`). Therefore, **(Press Enter to accept the default _work directory or provide a custom value when prompted.)**  

### Step 3: Start the Runner and bring it `Online`.
Start the runner manually:
```sh
./run.sh
```

To run the runner as a systemd service:
```sh
sudo ./svc.sh install
sudo ./svc.sh start
```

### Step 4: Verify the Runner
1. Go to **Settings > Actions > Runners** in your GitHub repository.
2. The runner should appear as **Online**.
3. Run a GitHub Actions workflow to test it.

### Step 5: Updating the Runner
To update the runner when a new version is released:
```sh
./svc.sh stop
./config.sh remove
rm -rf *

# Redownload and extract the latest version
curl -o actions-runner-linux-x64-2.322.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.322.0/actions-runner-linux-x64-2.322.0.tar.gz

# Reconfigure the runner
./config.sh --url https://github.com/YOUR_GITHUB_REPO --token YOUR_RUNNER_TOKEN

# Restart the Runner manually
./run.sh

Or

# Restart the service
sudo ./svc.sh install
sudo ./svc.sh start
```

### Step 6: Removing the Runner
To remove the runner from GitHub:
```sh
./config.sh remove
```

Then delete the runner directory:
```sh
cd ..
rm -rf actions-runner
```

## Conclusion
By following this guide, You have successfully set up a self-hosted GitHub Actions runner on Linux. This allows you to run workflows on your own infrastructure, providing greater flexibility and control over CI/CD pipelines.

## Additional Resources
1. [GitHub Actions Self-Hosted Runners Documentation](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners)
2. [Vagrant Cheat Sheet](https://gist.github.com/wpscholar/a49594e2e2b918f4d0c4)

