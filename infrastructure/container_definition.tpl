[
  {
    "name": "${application}",
    "image": "leonardocordeiro/ecs-example-app:${commit_hash}",
    "cpu": 10,
    "memory": 512,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 0
      }
    ]
  }
]