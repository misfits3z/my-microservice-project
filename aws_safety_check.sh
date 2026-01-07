#!/bin/bash

echo "🔍 Running AWS Safety Check..."
echo

danger=0

check() {
    local label="$1"
    local cmd="$2"
    local result=$(eval "$cmd")
    if [[ -n "$result" ]]; then
        echo "❗ $label:"
        echo "$result"
        echo
        danger=1
    fi
}

# 1. EC2 instances
check "EC2 Instances" \
"aws ec2 describe-instances --query \"Reservations[*].Instances[?State.Name=='running'].InstanceId\" --output text"

# 2. Load Balancers (ALB/NLB)
check "Load Balancers (ELBv2)" \
"aws elbv2 describe-load-balancers --query \"LoadBalancers[*].LoadBalancerName\" --output text"

# Classic ELB
check "Classic ELB" \
"aws elb describe-load-balancers --query \"LoadBalancerDescriptions[*].LoadBalancerName\" --output text"

# 3. NAT Gateways
check \"NAT Gateways\" \
"aws ec2 describe-nat-gateways --query \"NatGateways[?State=='available'].NatGatewayId\" --output text"

# 4. Elastic IPs
check \"Elastic IPs\" \
"aws ec2 describe-addresses --query \"Addresses[*].PublicIp\" --output text"

# 5. Auto Scaling Groups
check \"Auto Scaling Groups\" \
"aws autoscaling describe-auto-scaling-groups --query \"AutoScalingGroups[*].AutoScalingGroupName\" --output text"

# 6. EKS Clusters
check \"EKS Clusters\" \
"aws eks list-clusters --query \"clusters\" --output text"

echo "------------------------------------"
if [[ $danger -eq 0 ]]; then
    echo "🟢 SAFE: No cost-generating resources found!"
else
    echo "🔴 WARNING: Resources above may cost money!"
fi
echo "------------------------------------"


# Дати права на запуск : chmod +x aws_safety_check.sh
# Запуск : ./aws_safety_check.sh