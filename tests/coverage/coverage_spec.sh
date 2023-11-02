
Describe 'sample'
  Describe 'bc command'
    It 'performs addition'
      When run script ./target/debug/mush --version
      The output should eq "Mush 0.1.1 (2023-11-01)"
    End
  End
End
