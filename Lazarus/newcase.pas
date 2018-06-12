
{$PUSH}

{$OPTIMIZATION LEVEL3}
{$RANGECHECKS OFF}
{$OVERFLOWCHECKS OFF}
{$ASMMODE intel}


// This is a performant Assembler Jump Table
// optimized for linear case Statements without "gabs" and "ranges"
// like Automatastates
// ALIGN 5 not possible! why?
// ALIGN(8), DB $90 not possible
// ALIGN 8,DB $90 not possible? why
// ALIGN 5 $90
asm
 mov eax,3         // the "case" Selektor

 // Calculate where to jump
 // Assumption: this block is
 ALIGN 8
 shl eax,3         // {3} calculate the complete Offset Index*5 (5=the Sizeof(JumpTableElement))
 lea rbx, [rip+6]  // {7} load rbx with the instruction Pointer
                   //     "6" because of the Byte-Consumption of the next 3 asm Statements
 add rax,rbx       // {3} takes "3" Bytes!
 JMP rax           // {2} takes "2" Bytes!
 nop               // {1} takes "1" Byte Sum of {n} = 16 Bytes of Code

 // Jump-Table
 // ensure with "ALIGN" static size of every single JMP entry
 // Assembler may produce
 // JMP near {2 Bytes}
 // JMP far {5 Bytes}
 ALIGN 8
 JMP @case0
 ALIGN 8
 JMP @case1
 ALIGN 8
 JMP @case2
 ALIGN 8
 JMP @case3
 ALIGN 8
 JMP @case4
 ALIGN 8
 JMP @case5
 ALIGN 8
 JMP @case6
 ALIGN 8
 JMP @case7
 @case0:
 ADD rax,$00
 JMP @caseend
 @case1:
 ADD rax,$01
 JMP @caseend
 @case2:
 ADD rax,$02
 JMP @caseend
 DQ $9090909090909090,$9090909090909090,$9090909090909090,$9090909090909090,$9090909090909090
 DQ $9090909090909090,$9090909090909090,$9090909090909090,$9090909090909090,$9090909090909090
 DQ $9090909090909090,$9090909090909090,$9090909090909090,$9090909090909090,$9090909090909090
 @case3:
 ADD rax,$03
 JMP @caseend
 @case4:
 ADD rax,$04
 JMP @caseend
 @case5:
 ADD rax,$05
 JMP @caseend
 @case6:
 ADD rax,$06
 JMP @caseend
 @case7:
 ADD rax,$07
 JMP @caseend
 @caseelse:
 nop
 @caseend:
end;



    // mark that one more Octet has gone now
{$IFDEF CPUx86_64}
asm

 MOV rax,self    // mov rax,QWORD PTR [rbp-0x8]
 DEC [rax+Octets]  // dec DWORD PTR [rax+0x96]

end; //  end ['RAX']; -> just show how "result" works
{$else CPUx86_64}
     dec(Octets);
{$endif CPUx86_64}

{$POP}
