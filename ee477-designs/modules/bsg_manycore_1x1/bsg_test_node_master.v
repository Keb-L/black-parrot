/**
 * This file is used to instantiate all of the FSB master
 * nodes on the gateway chip. This specific file will instantiate
 * a trace-replay and a trace-rom for each node. The trace-rom
 * needs to have the module name bsg_trace_master_N_rom where
 * N is the master node ID.
 */

`define bsg_trace_master_n_rom(n)                                \
  bsg_trace_master_``n``_rom #(.width_p(rom_data_width_lp)       \
                              ,.addr_width_p(rom_addr_width_lp)) \
    trace_rom_``n``                                              \
      (.addr_i(rom_addr_li)                                      \
      ,.data_o(rom_data_lo));

module bsg_test_node_master

    import bsg_fsb_pkg::*;

 #(parameter ring_width_p="inv"
  ,parameter master_id_p="inv"
  ,parameter client_id_p="inv"
  )

  (input  clk_i
  ,input  reset_i
  ,input  en_i
  
  ,input                     v_i
  ,input  [ring_width_p-1:0] data_i
  ,output                    ready_o
  
  ,output                    v_o
  ,output [ring_width_p-1:0] data_o
  ,input                     yumi_i
  );
    
  logic done_lo;

  if (master_id_p == 0) begin

    assign done_lo = mc_master_node.finish_lo;

    bsg_manycore_master_node #(.ring_width_p(ring_width_p), .master_id_p(master_id_p), .client_id_p(client_id_p))
      mc_master_node
        (.clk_i      (clk_i)
        ,.reset_i    (reset_i)
        ,.en_i       (en_i)

        /* input channel */
        ,.v_i        (v_i)
        ,.data_i     (data_i)
        ,.ready_o    (ready_o)

        /* output channel */
        ,.v_o        (v_o)
        ,.data_o     (data_o)
        ,.yumi_i     (yumi_i));
  end

endmodule

