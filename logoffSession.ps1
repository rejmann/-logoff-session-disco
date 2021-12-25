$sessions = query session | # Busca todas as sessões 
            ?{ $_ -notmatch '^ SESSIONNAME' } | # Desconsidera o sessionname
            %{
                $item = "" | Select "Active", "SessionName", "Username", "Id", "State", "Type", "Device"
                $item.Active = $_.Substring(0,1) -match '&gt;'
                $item.SessionName = $_.Substring(1,18).Trim()
                $item.Username = $_.Substring(19,20).Trim()
                $item.Id = $_.Substring(39,9).Trim()
                $item.State = $_.Substring(48,8).Trim()
                $item.Type = $_.Substring(56,12).Trim()
                $item.Device = $_.Substring(68).Trim()
                $item
            } # Prepara array das sessões

foreach ($session in $sessions) # Loop no array de sessões
{   
    # Verifica se o ID é diferente de 0 e se o estado é desconectado
    if ($session.Id -ne 0 -and $session.State -eq "Disco") { 
        
        # Realiza logoff do ID que tem a sessão desconectada
        logoff $session.Id

    }  
}