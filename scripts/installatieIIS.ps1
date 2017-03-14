echo "Downloading and installing IIS"

#Download and install IIS 
import-module servermanager
add-windowsfeature web-server -includeallsubfeature

echo "IIS installation is complete"
