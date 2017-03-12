echo "IIS wordt geïnstalleerd"

import-module servermanager
add-windowsfeature web-server -includeallsubfeature

echo "IIS installatie is uitgevoerd"
