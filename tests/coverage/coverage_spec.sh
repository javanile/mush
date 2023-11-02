
Describe 'mush'
  Describe '--version'
    It 'performs addition'
      When run script ./target/debug/mush --version
      The output should eq "Mush 0.1.1 (2023-11-01)"
    End
  End

  Describe 'bc command'
    It 'performs addition'
      When run script ./target/debug/mush --help
      The output should eq "$(cat ./tests/fixtures/ui/command/mush/help.out)"
    End
  End
End
