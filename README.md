# iosBtBackground

Jenom ukázka jak zprovoznit jednoduché připojení ke konkrétnímu zařízení spodporou připojení na pozadí. Nutno dodržet dvě věci, aby to fungovalo:
- je nutno si držet odkaz na peripheral, ke kterému se aplikace má připojit (jinak hlásí misuse api)
- pokud má být reakce na zpracování údálosti od zařízení delší než 10s musí se řešit přes beginBackgroundTaskWithExpirationHandler (jinak OS zpracování události odstřelí)
