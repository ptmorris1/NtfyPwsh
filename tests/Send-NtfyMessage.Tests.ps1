# Pester integration test for Send-NtfyMessage (no mocks)

Remove-Module NtfyPwsh -ErrorAction SilentlyContinue
Import-Module 'D:\OneDrive\PowerShell\GIT\NtfyPwsh\NtfyPwsh.psm1' -Force

Describe 'Send-NtfyMessage Integration' {
    It 'Should post a basic message and return a valid response' {
        $topic = "ntfypwsh"
        $body = 'Hello from NtfyPwsh integration test!'
        $result = Send-NtfyMessage -Topic $topic -Body $body
        $result | Should -Not -BeNullOrEmpty
        $result | Should -HaveProperty 'id'
        $result | Should -HaveProperty 'time'
        $result.URI | Should -BeExactly "https://ntfy.sh/$topic"
    }
}
