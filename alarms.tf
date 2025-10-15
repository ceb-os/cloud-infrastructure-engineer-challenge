# alarma para CPU
resource "aws_cloudwatch_metric_alarm" "rds_cpu_usage_high" {
  alarm_name                = "rds_cpu_alarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 3
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/RDS"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 90
  alarm_description         = "Trigger alarm if CPU usage is above 90%."
# tengo que levantar un sns topic
#   alarm_actions             = [aws_sns_topic.rds_alarms_topic.arn]
#   ok_actions                = [aws_sns_topic.rds_alarms_topic.arn]

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.nanlabs-rds.identifier
  }
}

# alarma para memoria
resource "aws_cloudwatch_metric_alarm" "rds_memory_low" {
  alarm_name                = "RDS-Low-Freeable-Memory"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = 3
  metric_name               = "FreeableMemory"
  namespace                 = "AWS/RDS"
  period                    = 120
  statistic                 = "Average"
  
  # umbral en bytes 100mb
  threshold                 = 104857600
  
  alarm_description         = "Trigger alarm if RDS freeable memory drops below 100 MB."
  actions_enabled           = true
# tengo que levantar un sns topic
#   alarm_actions             = [aws_sns_topic.rds_alarms_topic.arn]
#   ok_actions                = [aws_sns_topic.rds_alarms_topic.arn]

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.nanlabs-rds.identifier
  }
}

# alarma para storage
resource "aws_cloudwatch_metric_alarm" "rds_storage_low" {
  alarm_name                = "RDS-Low-FreeStorageSpace"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = 1
  metric_name               = "FreeStorageSpace"
  namespace                 = "AWS/RDS"
  period                    = 300
  statistic                 = "Average"
  
  # umbral en bytes, 1gb
  threshold                 = 1073741824 
  
  alarm_description         = "Trigger alarm if RDS free storage space drops below 1 GB."
  actions_enabled           = true
# tengo que levantar un snsp topci
#   alarm_actions             = [aws_sns_topic.rds_alarms_topic.arn]
#   ok_actions                = [aws_sns_topic.rds_alarms_topic.arn]

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.nanlabs-rds.identifier
  }
}