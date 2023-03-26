#!/bin/bash
# Author: Nisrin Ahmed aka Wh1teDrvg0n. Modified by neftalito.

  flushTables(){
    # IPv4 flush
      iptables -P INPUT ACCEPT
      iptables -P FORWARD ACCEPT
      iptables -P OUTPUT ACCEPT
      iptables -t nat -F
      iptables -t mangle -F
      iptables -F
      iptables -X
      iptables -Z

    # IPv6 flush
      ip6tables -P INPUT DROP
      ip6tables -P FORWARD DROP
      ip6tables -P OUTPUT DROP
      ip6tables -t nat -F
      ip6tables -t mangle -F
      ip6tables -F
      ip6tables -X
      ip6tables -Z
    
    # Show IPtables
      iptables -S
  }

  createMachineRules(){
    # Ping machine
      iptables -A INPUT -p icmp -i tun0 -s $1 --icmp-type echo-request -j ACCEPT
      iptables -A INPUT -p icmp -i tun0 -s $1 --icmp-type echo-reply -j ACCEPT

      iptables -A INPUT -p icmp -i tun0 --icmp-type echo-request -j DROP  
      iptables -A INPUT -p icmp -i tun0 --icmp-type echo-reply -j DROP

      iptables -A OUTPUT -p icmp -o tun0 -d $1 --icmp-type echo-reply -j ACCEPT
      iptables -A OUTPUT -p icmp -o tun0 -d $1 --icmp-type echo-request -j ACCEPT

      iptables -A OUTPUT -p icmp -o tun0 --icmp-type echo-request -j DROP
      iptables -A OUTPUT -p icmp -o tun0 --icmp-type echo-reply -j DROP

    # Allow VPN connection only from machine
      iptables -A INPUT -i tun0 -p tcp -s $1 -j ACCEPT
      iptables -A OUTPUT -o tun0 -p tcp -d $1 -j ACCEPT
      iptables -A INPUT -i tun0 -p udp -s $1 -j ACCEPT
      iptables -A OUTPUT -o tun0 -p udp -d $1 -j ACCEPT

      iptables -A INPUT -i tun0 -j DROP
      iptables -A OUTPUT -o tun0 -j DROP

    # Show IPtables
      iptables -S
  }
  
  # Check if user is root
  if [[ $(id -u) -ne 0 ]]
  then
    echo "This script must be run as root"
    exit 1
  fi

  # Exit if there's no parameters
  if [ $# -eq 0 ]
  then
    echo "Usage: sudo ./safevpn-thm.sh <machine ip> | sudo ./safevpn-thm.sh --flush."
    exit 1
  # If there's parameters check if it's "--flush" to just flush tables
  else 
    if [ $1 = "--flush" ]
    then
      echo "Flushing iptables.."
      flushTables
    else
      echo "Creating rules for IP: $1"
      flushTables
      createMachineRules $1
    fi
  fi
