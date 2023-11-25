# frozen_string_literal: true

require 'dumb_vm'

# This file is a test for describing the VerySimpleCPU architecture with the
# DumbVM DSL, details for the architecture can be found here: http://www.cpu.tc/rtl/

DumbVM.describe(VerySimpleCPU) do
  # Instruction word
  register :iw, size: bits(32)
  # Program counter
  register :pc, size: bits(14), init_value: 0
  # General-purpose registers
  register :r1, size: bits(32)
  register :r2, size: bits(32)

  fetch { iw <= memory.read_bytes(8, offset: pc) }

  decode do
    case iw[28..31]
    when 0x00 then :ADD
    when 0x01 then :ADDi
    when 0x08 then :CP
    when 0x09 then :CPi
    when 0x0C then :BZJ
    when 0x0D then :BZJi
    end
  end

  # rubocop:disable Lint/Void This is because the <= operation is being used in a weird manner
  operation :ADD do
    r1 <= memory[iw[27..14]]
    r2 <= memory[iw[13..0]]
    memory[iw[27..14]] <= r1 + r2
    pc <= pc + 1
  end

  operation :ADDi do
    r1 <= memory[iw[27..14]]
    r2 <= iw[13..0]
    memory[iw[27..14]] <= r1 + r2
    pc <= pc + 1
  end

  operation :CP do
    r1 <= memory[iw[13..0]]
    mem[iw[27..14]] <= r2
    pc <= pc + 1
  end

  operation :CPi do
    r1 <= iw[13..0]
    mem[iw[27..14]] <= r2
    pc <= pc + 1
  end

  operation :BZJ do
    r1 <= memory[iw[27..14]]
    r2 <= memory[iw[13..0]]
    pc <= r2 == 0 ? r1 : (pc + 1)
  end

  operation :BZJi do
    r1 <= memory[iw[27..14]]
    r2 <= iw[13..0]
    pc <= r2 == 0 ? r1 : (pc + 1)
  end
  # rubocop:enable Lint/Void
end
