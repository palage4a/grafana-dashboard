local grafana = import 'grafonnet/grafana.libsonnet';

local dashboard = import 'dashboard/dashboard.libsonnet';
local section = import 'dashboard/section.libsonnet';
local variable = import 'dashboard/variable.libsonnet';

function(
  datasource,
  policy,
  measurement,
  alias,
  title='Tarantool dashboard',
) dashboard.new(
  grafana.dashboard.new(
    title=title,
    description='Dashboard for Tarantool application and database server monitoring, based on grafonnet library.',
    editable=true,
    schemaVersion=21,
    time_from='now-3h',
    time_to='now',
    refresh='30s',
    tags=['tarantool'],
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
    type='datasource',
    id='influxdb',
    name='InfluxDB',
    version='1.0.0'
  )
).addPanels(
  section.cluster_influxdb(
    datasource_type=variable.datasource_type.influxdb,
    datasource=datasource,
    policy=policy,
    measurement=measurement,
    alias=alias,
  )
).addPanels(
  section.replication(
    datasource_type=variable.datasource_type.influxdb,
    datasource=datasource,
    policy=policy,
    measurement=measurement,
    alias=alias,
  )
).addPanels(
  section.http(
    datasource_type=variable.datasource_type.influxdb,
    datasource=datasource,
    policy=policy,
    measurement=measurement,
    alias=alias,
  )
).addPanels(
  section.net(
    datasource_type=variable.datasource_type.influxdb,
    datasource=datasource,
    policy=policy,
    measurement=measurement,
    alias=alias,
  )
).addPanels(
  section.slab(
    datasource_type=variable.datasource_type.influxdb,
    datasource=datasource,
    policy=policy,
    measurement=measurement,
    alias=alias,
  )
).addPanels(
  section.mvcc(
    datasource_type=variable.datasource_type.influxdb,
    datasource=datasource,
    policy=policy,
    measurement=measurement,
    alias=alias,
  )
).addPanels(
  section.space(
    datasource_type=variable.datasource_type.influxdb,
    datasource=datasource,
    policy=policy,
    measurement=measurement,
    alias=alias,
  )
).addPanels(
  section.vinyl(
    datasource_type=variable.datasource_type.influxdb,
    datasource=datasource,
    policy=policy,
    measurement=measurement,
    alias=alias,
  )
).addPanels(
  section.cpu(
    datasource_type=variable.datasource_type.influxdb,
    datasource=datasource,
    policy=policy,
    measurement=measurement,
    alias=alias,
  )
).addPanels(
  section.runtime(
    datasource_type=variable.datasource_type.influxdb,
    datasource=datasource,
    policy=policy,
    measurement=measurement,
    alias=alias,
  )
).addPanels(
  section.luajit(
    datasource_type=variable.datasource_type.influxdb,
    datasource=datasource,
    policy=policy,
    measurement=measurement,
    alias=alias,
  )
).addPanels(
  section.operations(
    datasource_type=variable.datasource_type.influxdb,
    datasource=datasource,
    policy=policy,
    measurement=measurement,
    alias=alias,
  )
).addPanels(
  section.crud(
    datasource_type=variable.datasource_type.influxdb,
    datasource=datasource,
    policy=policy,
    measurement=measurement,
    alias=alias,
  )
).addPanels(
  section.expirationd(
    datasource_type=variable.datasource_type.influxdb,
    datasource=datasource,
    policy=policy,
    measurement=measurement,
    alias=alias,
  )
)
