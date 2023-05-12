local grafana = import 'grafonnet/grafana.libsonnet';

local dashboard = import 'dashboard/dashboard.libsonnet';
local section = import 'dashboard/section.libsonnet';
local variable = import 'dashboard/variable.libsonnet';

function(
  datasource,
  job,
  alias,
  title='Tarantool Data Grid dashboard',
) dashboard.new(
  grafana.dashboard.new(
    title=title,
    description='Dashboard for Tarantool Data Grid ver. 2 application monitoring, based on grafonnet library.',
    editable=true,
    schemaVersion=21,
    time_from='now-3h',
    time_to='now',
    refresh='30s',
    tags=['tarantool', 'TDG'],
  ).addRequired(
    type='grafana',
    id='grafana',
    name='Grafana',
    version='8.0.0'
  ).addRequired(
    type='panel',
    id='graph',
    name='Graph',
    version=''
  ).addRequired(
    type='panel',
    id='timeseries',
    name='Timeseries',
    version=''
  ).addRequired(
    type='panel',
    id='text',
    name='Text',
    version=''
  ).addRequired(
    type='panel',
    id='stat',
    name='Stat',
    version='',
  ).addRequired(
    type='panel',
    id='table',
    name='Table',
    version='',
  ).addRequired(
    type='datasource',
    id='prometheus',
    name='Prometheus',
    version='1.0.0'
  )
).addPanels(
  section.cluster_prometheus(
    datasource_type=variable.datasource_type.prometheus,
    datasource=datasource,
    job=job,
    alias=alias,
  )
).addPanels(
  section.replication(
    datasource_type=variable.datasource_type.prometheus,
    datasource=datasource,
    job=job,
    alias=alias,
  )
).addPanels(
  section.net(
    datasource_type=variable.datasource_type.prometheus,
    datasource=datasource,
    job=job,
    alias=alias,
  )
).addPanels(
  section.slab(
    datasource_type=variable.datasource_type.prometheus,
    datasource=datasource,
    job=job,
    alias=alias,
  )
).addPanels(
  section.mvcc(
    datasource_type=variable.datasource_type.prometheus,
    datasource=datasource,
    job=job,
    alias=alias,
  )
).addPanels(
  section.space(
    datasource_type=variable.datasource_type.prometheus,
    datasource=datasource,
    job=job,
    alias=alias,
  )
).addPanels(
  section.vinyl(
    datasource_type=variable.datasource_type.prometheus,
    datasource=datasource,
    job=job,
    alias=alias,
  )
).addPanels(
  section.cpu_extended(
    datasource_type=variable.datasource_type.prometheus,
    datasource=datasource,
    job=job,
    alias=alias,
  )
).addPanels(
  section.runtime(
    datasource_type=variable.datasource_type.prometheus,
    datasource=datasource,
    job=job,
    alias=alias,
  )
).addPanels(
  section.luajit(
    datasource_type=variable.datasource_type.prometheus,
    datasource=datasource,
    job=job,
    alias=alias,
  )
).addPanels(
  section.operations(
    datasource_type=variable.datasource_type.prometheus,
    datasource=datasource,
    job=job,
    alias=alias,
  )
).addPanels(
  section.tdg_kafka_common(
    datasource_type=variable.datasource_type.prometheus,
    datasource=datasource,
    job=job,
    alias=alias,
  )
).addPanels(
  section.tdg_kafka_brokers(
    datasource_type=variable.datasource_type.prometheus,
    datasource=datasource,
    job=job,
    alias=alias,
  )
).addPanels(
  section.tdg_kafka_topics(
    datasource_type=variable.datasource_type.prometheus,
    datasource=datasource,
    job=job,
    alias=alias,
  )
).addPanels(
  section.tdg_kafka_consumer(
    datasource_type=variable.datasource_type.prometheus,
    datasource=datasource,
    job=job,
    alias=alias,
  )
).addPanels(
  section.tdg_kafka_producer(
    datasource_type=variable.datasource_type.prometheus,
    datasource=datasource,
    job=job,
    alias=alias,
  )
).addPanels(
  section.expirationd(
    datasource_type=variable.datasource_type.prometheus,
    datasource=datasource,
    job=job,
    alias=alias,
  )
).addPanels(
  section.tdg_tuples(
    datasource_type=variable.datasource_type.prometheus,
    datasource=datasource,
    job=job,
    alias=alias,
  )
).addPanels(
  section.tdg_file_connectors(
    datasource_type=variable.datasource_type.prometheus,
    datasource=datasource,
    job=job,
    alias=alias,
  )
).addPanels(
  section.tdg_graphql(
    datasource_type=variable.datasource_type.prometheus,
    datasource=datasource,
    job=job,
    alias=alias,
  )
).addPanels(
  section.tdg_iproto(
    datasource_type=variable.datasource_type.prometheus,
    datasource=datasource,
    job=job,
    alias=alias,
  )
).addPanels(
  section.tdg_rest_api(
    datasource_type=variable.datasource_type.prometheus,
    datasource=datasource,
    job=job,
    alias=alias,
  )
).addPanels(
  section.tdg_tasks(
    datasource_type=variable.datasource_type.prometheus,
    datasource=datasource,
    job=job,
    alias=alias,
  )
)
