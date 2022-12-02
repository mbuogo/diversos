#!/usr/bin/env python3

import re
import random
import sys

class PIS:
    """Validador e Gerador aleatorio de numero PIS"""

    def __init__(self, pis = ""):
        """Especifique um PIS para validar
           pis = Numero PIS a validar.
        """
        if pis:
            pis = self._sanitiza(pis)
            self.pis = f"{int(pis):011}"
            self.prefixo = self.pis[:10]

    def _sanitiza(self, pis):
        return re.sub(r"[^0-9]", "", str(pis))

    def digito_verificador(self, prefixo = ""):
        """Gera o digito verificador (11o) dos primeiros 10 digitos do PIS
           NNN.NNNNN.NN-D    N='Digitos a validar'  D='Digito Validador'
           Algoritmo: https://macoratti.net/alg_pis.htm
        """
        prefixo = self._sanitiza(prefixo or self.prefixo)[:10]
        pesos = (3,2,9,8,7,6,5,4,3,2)
        dv = 11 - sum(int(d)*pesos[i] for i, d in enumerate(prefixo)) % 11
        if dv > 9:
            dv = 0
        return str(dv)

    def valido(self):
        """Retorna (bool) se o PIS informado no construtor eh valido"""
        return self.digito_verificador() == self.pis[10] if self.pis else False

    def random(self, limite = 0):
        """Generator infinito de numeros PIS validos aleatorios
        limite = Define um quantidade maxima de numeros PIS a gerar
        """
        cache = []
        i = 0
        while not limite or len(cache) < int(limite):
            prefix = random.randint(0, 10000000000)
            pis = f"{prefix:010}{self.digito_verificador(prefix)}"
            if pis not in cache:
                cache.append(pis)
                yield PIS(pis)

    def formata(self, pis = ""):
        """Formatador de numero PIS
           NNN.NNNNN.NN-D    N='Digitos a validar'  D='Digito Validador'
        """
        return f"{pis[:3]}.{pis[3:8]}.{pis[8:10]}-{pis[10]}"""

    def __repr__(self):
        return self.pis

    def __str__(self):
        return self.formata(self.__repr__())
