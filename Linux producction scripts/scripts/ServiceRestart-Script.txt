#!/bin/bash
service_name="your_service"

sudo systemctl restart "$service_name"
echo "Service $service_name restarted."