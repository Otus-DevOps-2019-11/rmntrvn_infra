#!/bin/bash
tee /lib/systemd/system/puma.service << EOF
[Unit]
Description=Unit for puma server

[Service]
WorkingDirectory=/home/rmntrvn/reddit
ExecStart=/usr/local/bin/puma
Restart=always
RestartSec=15
[Install]
WantedBy=multi-user.target
EOF
systemctl enable puma.service
systemctl start puma.service
