# TradingBot

Un bot de trading automatisé pour **MetaTrader 5 (MT5)**, conçu pour détecter les blocs d'ordre et exécuter des transactions basées sur l'analyse des tendances et des déséquilibres de prix.

## 🚀 Fonctionnalités

- **Détection des blocs d'ordre :**
  - Identifie automatiquement les blocs d'ordre haussiers et baissiers.
  - Repère les niveaux de prix clés pour des entrées potentielles.

- **Analyse des tendances avec EMA :**
  - Utilise les moyennes mobiles exponentielles (EMA) rapides et lentes pour détecter les tendances haussières et baissières.
  - Périodes d'EMA configurables pour des stratégies personnalisées.

- **Exécution automatisée des ordres :**
  - Place des ordres BUY ou SELL à des niveaux optimaux avec des Stop Loss (SL) et Take Profit (TP) définis.
  - Limite le nombre de transactions simultanées pour une gestion des risques efficace.

- **Code modulaire :**
  - Structuré en plusieurs modules pour une meilleure lisibilité et extensibilité.

## 📂 Structure du projet
```├── OrderBlockEA.mq5           # Fichier principal du bot
├── EMA_Calculations.mqh       # Fonctions pour le calcul des EMA
├── Trend_Detection.mqh        # Détection des tendances
├── OrderBlock_Detection.mqh   # Détection des blocs d’ordre
├── Order_Management.mqh       # Gestion des ordres
├── Utility_Functions.mqh      # Fonctions utilitaires
```
## 🛠️ Installation

1. Ouvrez MetaTrader 5, puis allez dans **Fichier > Ouvrir le dossier des données**.
2. Naviguez jusqu'au dossier `MQL5/Experts` et créez un nouveau dossier nommé `OrderBlockEA`.
3. Copiez les fichiers suivants dans le dossier `OrderBlockEA` :
   - `OrderBlockEA.mq5`
   - `EMA_Calculations.mqh`
   - `Trend_Detection.mqh`
   - `OrderBlock_Detection.mqh`
   - `Order_Management.mqh`
   - `Utility_Functions.mqh`
4. Ouvrez **MetaEditor**, compilez le fichier `OrderBlockEA.mq5` (touche `F7`) et assurez-vous qu'il n'y a pas d'erreurs.
5. Dans MetaTrader 5, attachez le bot à un graphique et configurez les paramètres souhaités.

## ⚙️ Paramètres configurables

| Paramètre          | Description                              | Valeur par défaut |
|--------------------|------------------------------------------|-------------------|
| `LotSize`          | Taille fixe du lot                      | `20`              |
| `StopLossPips`     | Stop Loss en pips                       | `5`              |
| `TakeProfitPips`   | Take Profit en pips                     | `10`              |
| `MaxTrades`        | Nombre maximum de transactions actives  | `10`              |
| `FastEMAPeriod`    | Période de l'EMA rapide                 | `12`              |
| `SlowEMAPeriod`    | Période de l'EMA lente                  | `26`              |

## 🔍 Exemple de stratégie

1. **Tendance détectée :**  
   - Le marché est haussier (EMA rapide > EMA lente).  
   - Un bloc d'ordre haussier est identifié.  
   
2. **Placement d'un ordre :**  
   - Lorsque le prix revient au niveau du bloc d'ordre, le bot place un ordre BUY avec un SL et un TP définis.  

3. **Résultat :**  
   - Le bot gère automatiquement l'ordre jusqu'à la clôture (SL ou TP atteint).

## 🤝 Contribuer

Les contributions sont les bienvenues ! Pour contribuer :

1. Forkez ce dépôt.
2. Créez une branche pour votre fonctionnalité ou correction de bug :
   ```bash
   git checkout -b feature/ma-nouvelle-fonctionnalite


