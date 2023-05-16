local grafana = import 'grafonnet/grafana.libsonnet';

local config = import 'dashboard/build/config.libsonnet';
local dashboard_raw = import 'dashboard/build/influxdb/dashboard_raw.libsonnet';
local variable = import 'dashboard/variable.libsonnet';

local DATASOURCE = std.extVar('DATASOURCE');
local POLICY = std.extVar('POLICY');
local MEASUREMENT = std.extVar('MEASUREMENT');
local WITH_INSTANCE_VARIABLE = (std.asciiUpper(std.extVar('WITH_INSTANCE_VARIABLE')) == 'TRUE');
local TITLE = if std.extVar('TITLE') != '' then std.extVar('TITLE') else 'Tarantool dashboard';

local cfg = config.prepare({
  type: variable.datasource_type.influxdb,
  title: TITLE,
  description: 'Dashboard for Tarantool application and database server monitoring, based on grafonnet library.',
  grafana_tags: ['tarantool'],
  datasource: DATASOURCE,
  policy: POLICY,
  measurement: MEASUREMENT,
  filters: if WITH_INSTANCE_VARIABLE then { label_pairs_alias: ['=~', variable.influxdb.alias] } else {},
  sections: [
    'cluster',
    'replication',
    'http',
    'net',
    'slab',
    'mvcc',
    'space',
    'vinyl',
    'cpu',
    'runtime',
    'luajit',
    'operations',
    'crud',
    'expirationd',
  ],
});

if WITH_INSTANCE_VARIABLE then
  dashboard_raw(cfg).addTemplate(
    grafana.template.new(
      name='alias',
      datasource=cfg.datasource,
      query=std.format(
        'SHOW TAG VALUES FROM %(policy_prefix)s"%(measurement)s" WITH KEY="label_pairs_alias"',
        {
          policy_prefix: if cfg.policy == 'default' then '' else std.format('"%s".', cfg.policy),
          measurement: cfg.measurement,
        },
      ),
      includeAll=true,
      multi=true,
      current='all',
      label='Instances',
      refresh='time',
    )
  ).build()
else
  dashboard_raw(cfg).build()
