local grafana = import 'grafonnet/grafana.libsonnet';

local common = import 'dashboard/panels/common.libsonnet';
local variable = import 'dashboard/variable.libsonnet';

local influxdb = grafana.influxdb;
local prometheus = grafana.prometheus;

local cpu = import 'dashboard/panels/cpu.libsonnet';

cpu +
{
  local procstat_thread_time_graph(
    cfg,
    title,
    description,
    kind,
  ) = common.default_graph(
    cfg=cfg,
    title=title,
    description=description,
    labelY1='ticks per second',
    min=0,
    decimalsY1=2,
    panel_width=12,
  ).addTarget(
    common.target(
      cfg,
      'tnt_cpu_thread',
      additional_filters={
        [variable.datasource_type.prometheus]: { kind: ['=', kind] },
        [variable.datasource_type.influxdb]: { label_pairs_kind: ['=', kind] },
      },
      legend={
        [variable.datasource_type.prometheus]: '{{alias}} — {{thread_name}}',
        [variable.datasource_type.influxdb]: '$tag_label_pairs_alias — $tag_label_pairs_thread_name',
      },
      group_tags=['label_pairs_alias', 'label_pairs_thread_name'],
      rate=true,
    ),
  ),

  procstat_thread_user_time(
    cfg,
    title='Thread user time',
    description=|||
      Amount of time that each process has been scheduled
      in user mode, measured in clock ticks (divide by
      sysconf(_SC_CLK_TCK)).  This includes guest time,
      guest_time (time spent running a virtual CPU, see
      below), so that applications that are not aware of
      the guest time field do not lose that time from
      their calculations. Average ticks per second is displayed.

      Metrics are obtained by parsing `/proc/self/task/[pid]/stat`.
    |||,
  ): procstat_thread_time_graph(
    cfg,
    title,
    description,
    'user',
  ),

  procstat_thread_system_time(
    cfg,
    title='Thread system time',
    description=|||
      Amount of time that this process has been scheduled
      in kernel mode, measured in clock ticks (divide by
      sysconf(_SC_CLK_TCK)). Average ticks per second is displayed.

      Metrics are obtained by parsing `/proc/self/task/[pid]/stat`.
    |||,
  ): procstat_thread_time_graph(
    cfg,
    title,
    description,
    'system',
  ),
}
