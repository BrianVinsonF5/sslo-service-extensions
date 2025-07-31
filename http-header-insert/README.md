# SSL Orchestrator HTTP Header Insert

The HTTP Header Insert is an F5 SSL Orchestrator service extension designed to add a custom HTTP request header to every HTTP request intercepted by the SSL Orchestrator.

This extension inserts a header named X-Proxy-HTTP containing the following values:
* Client Source TCP Port
* Destination IP Address

The purpose of this header is to:
* Provide clear identification that traffic has been intercepted by SSL Orchestrator.
* Support cybersecurity analysis by offering basic context on where the traffic originated and its intended destination.

Requires:
* BIG-IP SSL Orchestrator 17.1.x (SSLO 11.1+)
* URLDB subscription -and/or- custom URL category

### To implement via installer:
1. Run the following from the BIG-IP shell to get the installer:
  ```bash
  curl -sk https://raw.githubusercontent.com/BrianVinsonF5/sslo-service-extensions/refs/heads/main/http-header-insert/http-header-insert-installer.sh -o http-header-insert-installer.sh
  chmod +x http-header-insert-installer.sh
  ```

2. Export the BIG-IP user:pass:
  ```bash
  export BIGUSER='admin:password'
  ```

3. Run the script to create all of theHTTP Header Insert objects
  ```bash
  ./http-header-insert-installer.sh
  ```

4. Add the resulting "ssloS_F5_HTTP_Header_insert" inspection service in SSLO to a decrypted traffic service chain. The installer creates a new inspection service name "ssloS_F5_HTTP_Header_insert". Add this inspection service to any service chain that can receive decrypted HTTP traffic. Service extension services will only trigger on decrypted HTTP, so can be inserted into service chains that may also see TLS intercepts traffic. SSL Orchestrator will simply bypass this service for anything that is not decrypted HTTP.

