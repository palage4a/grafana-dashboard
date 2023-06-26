local grafana = import 'grafonnet/grafana.libsonnet';

local common = import 'dashboard/panels/common.libsonnet';
local variable = import 'dashboard/variable.libsonnet';

local influxdb = grafana.influxdb;
local prometheus = grafana.prometheus;

{
  row:: common.row('Tarantool CPU statistics'),

  local getrusage_cpu_percentage_graph(
    cfg,
    title,
    description,
    metric_name,
  ) = common.default_graph(
    cfg,
    title=title,
    description=description,
    format='percentunit',
    decimalsY1=0,
    min=0,
    panel_width=12,
  ).addTarget(
    common.target(cfg, metric_name, rate=true)
  ),

  getrusage_cpu_user_time(
    cfg,
    title='CPU user time',
    description=|||
      This is the average share of time
      spent by instance process executing in user mode.
      Metrics obtained using `getrusage()` call.

      Panel works with `metrics >= 0.8.0`.
    |||,
  ): getrusage_cpu_percentage_graph(
    cfg=cfg,
    title=title,
    description=description,
    metric_name='tnt_cpu_user_time',
  ),

  getrusage_cpu_system_time(
    cfg,
    title='CPU system time',
    description=|||
      This is the average share of time
      spent by instance process executing in kernel mode.
      Metrics obtained using `getrusage()` call.

      Panel works with `metrics >= 0.8.0`.
    |||,
  ): getrusage_cpu_percentage_graph(
    cfg=cfg,
    title=title,
    description=description,
    metric_name='tnt_cpu_system_time',
  )
}
