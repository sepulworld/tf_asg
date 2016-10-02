resource "aws_elb" "main" {
  name = "${var.name}"

  internal                  = false
  cross_zone_load_balancing = true
  subnets                   = ["${split(",", var.subnet_ids)}"]
  security_groups           = ["${split(",",var.security_groups)}"]

  idle_timeout                = 30
  connection_draining         = true
  connection_draining_timeout = 15

  listener {
    lb_port            = 443
    lb_protocol        = "https"
    instance_port      = "${var.port}"
    instance_protocol  = "http"
    ssl_certificate_id = "${var.ssl_certificate_id}"
  }

  listener {
    lb_port            = "${var.health_check_port}"
    lb_protocol        = "http"
    instance_port      = "${var.health_check_port}"
    instance_protocol  = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    target              = "${var.health_check_url}"
    interval            = 30
  }

  tags {
    Name        = "${var.name}-ELB"
    managed_by  = "terraform"
  }
}
