local variable = import 'dashboard/variable.libsonnet';

local cluster = import 'dashboard/panels/cluster.libsonnet';
local cpu = import 'dashboard/panels/cpu.libsonnet';
local cpu_extended = import 'dashboard/panels/cpu_extended.libsonnet';
local crud = import 'dashboard/panels/crud.libsonnet';
local expirationd = import 'dashboard/panels/expirationd.libsonnet';
local http = import 'dashboard/panels/http.libsonnet';
local luajit = import 'dashboard/panels/luajit.libsonnet';
local mvcc = import 'dashboard/panels/mvcc.libsonnet';
local net = import 'dashboard/panels/net.libsonnet';
local operations = import 'dashboard/panels/operations.libsonnet';
local replication = import 'dashboard/panels/replication.libsonnet';
local runtime = import 'dashboard/panels/runtime.libsonnet';
local slab = import 'dashboard/panels/slab.libsonnet';
local space = import 'dashboard/panels/space.libsonnet';
local tdg_file_connectors = import 'dashboard/panels/tdg/file_connectors.libsonnet';
local tdg_graphql = import 'dashboard/panels/tdg/graphql.libsonnet';
local tdg_iproto = import 'dashboard/panels/tdg/iproto.libsonnet';
local tdg_kafka_brokers = import 'dashboard/panels/tdg/kafka/brokers.libsonnet';
local tdg_kafka_common = import 'dashboard/panels/tdg/kafka/common.libsonnet';
local tdg_kafka_consumer = import 'dashboard/panels/tdg/kafka/consumer.libsonnet';
local tdg_kafka_producer = import 'dashboard/panels/tdg/kafka/producer.libsonnet';
local tdg_kafka_topics = import 'dashboard/panels/tdg/kafka/topics.libsonnet';
local tdg_rest_api = import 'dashboard/panels/tdg/rest_api.libsonnet';
local tdg_tasks = import 'dashboard/panels/tdg/tasks.libsonnet';
local tdg_tuples = import 'dashboard/panels/tdg/tuples.libsonnet';
local vinyl = import 'dashboard/panels/vinyl.libsonnet';

local sections = {
  cluster : cluster,
  cpu : cpu,
  cpu_extended : cpu_extended,
  crud : crud,
  expirationd : expirationd,
  http : http,
  luajit : luajit,
  mvcc : mvcc,
  net : net,
  operations : operations,
  replication : replication,
  runtime : runtime,
  slab : slab,
  space : space,
  vinyl : vinyl,

};

local buildSection(name, cfg) =
  local s = std.get(sections, name, null);
  if s != null then
    std.map(function(ss)
              if 'alerts' in cfg && ss.key in cfg.alerts then
                ss.value(cfg).addAlert(cfg.alerts[ss.key])
              else
                ss.value(cfg),
            std.objectKeysValues(s));

  local getPrometheusPanels(cfg) =
    if cfg.type == variable.datasource_type.prometheus then [
      cluster.health_overview_table(cfg) { gridPos: { w: 12, h: 8, x: 0, y: 1 } },
      cluster.health_overview_stat(cfg) { gridPos: { w: 6, h: 3, x: 12, y: 1 } },
      cluster.memory_used_stat(cfg) { gridPos: { w: 3, h: 3, x: 18, y: 1 } },
      cluster.memory_reserved_stat(cfg) { gridPos: { w: 3, h: 3, x: 21, y: 1 } },
      cluster.http_rps_stat(cfg) { gridPos: { w: 4, h: 5, x: 12, y: 4 } },
      cluster.net_rps_stat(cfg) { gridPos: { w: 4, h: 5, x: 16, y: 4 } },
      cluster.space_ops_stat(cfg) { gridPos: { w: 4, h: 5, x: 20, y: 4 } },
    ] else if cfg.type == variable.datasource_type.influxdb then [];

{
  cluster(cfg):: [cluster.row] + getPrometheusPanels(cfg) + buildSection('cluster', cfg),
  replication(cfg):: [replication.row] + buildSection('replication', cfg),
  http(cfg):: [ http.row ] + buildSection('http', cfg),
  net(cfg):: [net.row] + buildSection('net', cfg),
  slab(cfg):: [slab.row] + buildSection('slab', cfg),
  mvcc(cfg):: [mvcc.row] + buildSection('mvcc', cfg),
  space(cfg):: [space.row] + buildSection('space', cfg),
  vinyl(cfg):: [vinyl.row] + buildSection('vinyl', cfg),
  cpu(cfg):: [cpu.row] + buildSection('cpu', cfg),
  cpu_extended(cfg):: [cpu_extended.row] + buildSection('cpu_extended', cfg),
  runtime(cfg):: [runtime.row] + buildSection('runtime', cfg),
  luajit(cfg):: [luajit.row] + buildSection('luajit', cfg),
  operations(cfg):: [operations.row] + buildSection('operations', cfg),
  crud(cfg):: [crud.row] + buildSection('crud', cfg),
  expirationd(cfg):: [expirationd.row] + buildSection('expirationd', cfg),

  tdg_kafka_common(cfg):: [
    tdg_kafka_common.row,
    tdg_kafka_common.queue_operations(cfg),
    tdg_kafka_common.message_current(cfg),
    tdg_kafka_common.message_size(cfg),
    tdg_kafka_common.requests(cfg),
    tdg_kafka_common.request_bytes(cfg),
    tdg_kafka_common.responses(cfg),
    tdg_kafka_common.response_bytes(cfg),
    tdg_kafka_common.messages_sent(cfg),
    tdg_kafka_common.message_bytes_sent(cfg),
    tdg_kafka_common.messages_received(cfg),
    tdg_kafka_common.message_bytes_received(cfg),
  ],

  tdg_kafka_brokers(cfg):: [
    tdg_kafka_brokers.row,
    tdg_kafka_brokers.stateage(cfg),
    tdg_kafka_brokers.connects(cfg),
    tdg_kafka_brokers.disconnects(cfg),
    tdg_kafka_brokers.poll_wakeups(cfg),
    tdg_kafka_brokers.outbuf(cfg),
    tdg_kafka_brokers.outbuf_msg(cfg),
    tdg_kafka_brokers.waitresp(cfg),
    tdg_kafka_brokers.waitresp_msg(cfg),
    tdg_kafka_brokers.requests(cfg),
    tdg_kafka_brokers.request_bytes(cfg),
    tdg_kafka_brokers.request_errors(cfg),
    tdg_kafka_brokers.request_retries(cfg),
    tdg_kafka_brokers.request_idle(cfg),
    tdg_kafka_brokers.request_timeout(cfg),
    tdg_kafka_brokers.responses(cfg),
    tdg_kafka_brokers.response_bytes(cfg),
    tdg_kafka_brokers.response_errors(cfg),
    tdg_kafka_brokers.response_corriderrs(cfg),
    tdg_kafka_brokers.response_idle(cfg),
    tdg_kafka_brokers.response_partial(cfg),
    tdg_kafka_brokers.requests_by_type(cfg),
    tdg_kafka_brokers.internal_producer_latency(cfg),
    tdg_kafka_brokers.internal_request_latency(cfg),
    tdg_kafka_brokers.broker_latency(cfg),
    tdg_kafka_brokers.broker_throttle(cfg),
  ],

  tdg_kafka_topics(cfg):: [
    tdg_kafka_topics.row,
    tdg_kafka_topics.age(cfg),
    tdg_kafka_topics.metadata_age(cfg),
    tdg_kafka_topics.topic_batchsize(cfg),
    tdg_kafka_topics.topic_batchcnt(cfg),
    tdg_kafka_topics.partition_msgq(cfg),
    tdg_kafka_topics.partition_xmit_msgq(cfg),
    tdg_kafka_topics.partition_fetchq_msgq(cfg),
    tdg_kafka_topics.partition_msgq_bytes(cfg),
    tdg_kafka_topics.partition_xmit_msgq_bytes(cfg),
    tdg_kafka_topics.partition_fetchq_msgq_bytes(cfg),
    tdg_kafka_topics.partition_messages_sent(cfg),
    tdg_kafka_topics.partition_message_bytes_sent(cfg),
    tdg_kafka_topics.partition_messages_consumed(cfg),
    tdg_kafka_topics.partition_message_bytes_consumed(cfg),
    tdg_kafka_topics.partition_messages_dropped(cfg),
    tdg_kafka_topics.partition_messages_in_flight(cfg),
  ],

  tdg_kafka_consumer(cfg):: [
    tdg_kafka_consumer.row,
    tdg_kafka_consumer.stateage(cfg),
    tdg_kafka_consumer.rebalance_age(cfg),
    tdg_kafka_consumer.rebalances(cfg),
    tdg_kafka_consumer.assignment_size(cfg),
  ],

  tdg_kafka_producer(cfg):: [
    tdg_kafka_producer.row,
    tdg_kafka_producer.idemp_stateage(cfg),
    tdg_kafka_producer.txn_stateage(cfg),
  ],

  tdg_tuples(cfg):: [
    tdg_tuples.row,
    tdg_tuples.tuples_scanned_average(cfg),
    tdg_tuples.tuples_returned_average(cfg),
    tdg_tuples.tuples_scanned_max(cfg),
    tdg_tuples.tuples_returned_max(cfg),
  ],

  tdg_file_connectors(cfg):: [
    tdg_file_connectors.row,
    tdg_file_connectors.files_processed(cfg),
    tdg_file_connectors.objects_processed(cfg),
    tdg_file_connectors.files_process_errors(cfg),
    tdg_file_connectors.file_size(cfg),
    tdg_file_connectors.current_bytes_processed(cfg),
    tdg_file_connectors.current_objects_processed(cfg),
  ],

  tdg_graphql(cfg):: [
    tdg_graphql.row,
    tdg_graphql.query_success_rps(cfg),
    tdg_graphql.query_success_latency(cfg),
    tdg_graphql.query_error_rps(cfg),
    tdg_graphql.mutation_success_rps(cfg),
    tdg_graphql.mutation_success_latency(cfg),
    tdg_graphql.mutation_error_rps(cfg),
  ],

  tdg_iproto(cfg):: [
    tdg_iproto.row,
    tdg_iproto.put_rps(cfg),
    tdg_iproto.put_latency(cfg),
    tdg_iproto.put_batch_rps(cfg),
    tdg_iproto.put_batch_latency(cfg),
    tdg_iproto.find_rps(cfg),
    tdg_iproto.find_latency(cfg),
    tdg_iproto.update_rps(cfg),
    tdg_iproto.update_latency(cfg),
    tdg_iproto.get_rps(cfg),
    tdg_iproto.get_latency(cfg),
    tdg_iproto.delete_rps(cfg),
    tdg_iproto.delete_latency(cfg),
    tdg_iproto.count_rps(cfg),
    tdg_iproto.count_latency(cfg),
    tdg_iproto.map_reduce_rps(cfg),
    tdg_iproto.map_reduce_latency(cfg),
    tdg_iproto.call_on_storage_rps(cfg),
    tdg_iproto.call_on_storage_latency(cfg),
  ],

  tdg_rest_api(cfg):: [
    tdg_rest_api.row,
    tdg_rest_api.read_success_rps(cfg),
    tdg_rest_api.read_error_4xx_rps(cfg),
    tdg_rest_api.read_error_5xx_rps(cfg),
    tdg_rest_api.read_success_latency(cfg),
    tdg_rest_api.read_error_4xx_latency(cfg),
    tdg_rest_api.read_error_5xx_latency(cfg),
    tdg_rest_api.write_success_rps(cfg),
    tdg_rest_api.write_error_4xx_rps(cfg),
    tdg_rest_api.write_error_5xx_rps(cfg),
    tdg_rest_api.write_success_latency(cfg),
    tdg_rest_api.write_error_4xx_latency(cfg),
    tdg_rest_api.write_error_5xx_latency(cfg),
  ],

  tdg_tasks(cfg):: [
    tdg_tasks.row,
    tdg_tasks.jobs_started(cfg),
    tdg_tasks.jobs_failed(cfg),
    tdg_tasks.jobs_succeeded(cfg),
    tdg_tasks.jobs_running(cfg),
    tdg_tasks.jobs_time(cfg),
    tdg_tasks.tasks_started(cfg),
    tdg_tasks.tasks_failed(cfg),
    tdg_tasks.tasks_succeeded(cfg),
    tdg_tasks.tasks_stopped(cfg),
    tdg_tasks.tasks_running(cfg),
    tdg_tasks.tasks_time(cfg),
    tdg_tasks.system_tasks_started(cfg),
    tdg_tasks.system_tasks_failed(cfg),
    tdg_tasks.system_tasks_succeeded(cfg),
    tdg_tasks.system_tasks_running(cfg),
    tdg_tasks.system_tasks_time(cfg),
  ],
}
