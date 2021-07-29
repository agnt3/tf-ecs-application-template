locals {
  ecs_cluster = data.terraform_remote_state.ecs_cluster.outputs.ecs_cluster_arn
  lb_arn      = data.terraform_remote_state.ecs_cluster.outputs.lb_arn
  vpc_id      = data.terraform_remote_state.ecs_cluster.outputs.vpc_id
}

resource "aws_lb_listener" "default" {
  load_balancer_arn = local.lb_arn
  protocol          = "HTTP"
  port              = 80

  default_action {
    type             = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<html> 404 - Not Found! </html>"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "default" {
  listener_arn       = aws_lb_listener.default.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default.arn
  }

  condition {
    path_pattern {
      values = [ "/api" ]
    }
  }
}

resource "aws_ecs_task_definition" "default" {
  family                = var.application
  container_definitions = data.template_file.container_definition.rendered
}

resource "aws_ecs_service" "default" {
  name                               = var.application
  cluster                            = local.ecs_cluster
  desired_count                      = 2
  task_definition                    = aws_ecs_task_definition.default.arn
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  depends_on = [aws_ecs_task_definition.default, aws_lb_target_group.default]

  load_balancer {
    container_name = var.application
    container_port = 3000
    target_group_arn = aws_lb_target_group.default.arn
  }
}

resource "aws_lb_target_group" "default" {
  name     = "tf-example-lb-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = local.vpc_id

  health_check {
    path                = "/health"
    matcher             = "200"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}