# TryHackMe safe VPN access
IPtables rules to only have incoming connections from the machine on TryHackMe.

Usage:

```bash
sudo chmod +x ./safevpn-thm.sh #Make it executable
sudo ./safevpn-thm.sh <ip of deployed machine>
```
Example:

```bash
sudo ./safevpn-thm.sh 10.10.10.10 #Create rules
sudo ./safevpn-thm.sh --flush #Flush rules
```
