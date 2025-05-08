#!/bin/bash

# Helper multi-commande pour messages-socket (global, prod d'abord)

DOCKER_COMPOSE_FILE="_docker/docker-compose.yml"
DOCKER_COMPOSE_PROD_FILE="_docker/docker-compose.prod.yml"

show_help() {
  echo ""
  echo "🛠️  Helper Docker - messages-socket (global)"
  echo ""
  echo "Commandes disponibles :"
  echo "  prod-up            → Démarrer tous les services (production)"
  echo "  prod-down          → Arrêter tous les services (production)"
  echo "  prod-destroy       → Supprimer complètement tous les conteneurs (production)"
  echo "  prod-refresh       → Rebuild + restart (production)"
  echo "  prod-restart       → Redémarrage (production)"
  echo "  up                 → Démarrer tous les services (développement)"
  echo "  down               → Arrêter tous les services (développement)"
  echo "  destroy            → Supprimer complètement tous les conteneurs (développement)"
  echo "  refresh            → Rebuild + restart (développement)"
  echo "  restart            → Redémarrage (développement)"
  echo "  logs-socket        → Afficher les logs du conteneur messages-socket"
  echo "  npm [...]          → Exécuter une commande npm dans le conteneur"
  echo "  sh                 → Accès shell dans le conteneur"
}

if [ $# -lt 1 ]; then
  show_help
  exit 0
fi

COMMAND=$1
shift

case "$COMMAND" in
  prod-up)
    docker compose -f "$DOCKER_COMPOSE_PROD_FILE" up -d
    ;;
  prod-down)
    docker compose -f "$DOCKER_COMPOSE_PROD_FILE" down
    ;;
  prod-destroy)
    echo "❗ Suppression complète des services en production"
    docker compose -f "$DOCKER_COMPOSE_PROD_FILE" down --volumes --remove-orphans
    ;;
  prod-refresh)
    echo "🔄 Rebuild + redémarrage (production)"
    docker compose -f "$DOCKER_COMPOSE_PROD_FILE" down
    docker compose -f "$DOCKER_COMPOSE_PROD_FILE" up -d --build
    ;;
  prod-restart)
    echo "🔄 Redémarrage (production)"
    docker compose -f "$DOCKER_COMPOSE_PROD_FILE" restart
    ;;
  up)
    docker compose -f "$DOCKER_COMPOSE_FILE" up -d
    ;;
  down)
    docker compose -f "$DOCKER_COMPOSE_FILE" down
    ;;
  destroy)
    echo "❗ Suppression complète des services en développement"
    docker compose -f "$DOCKER_COMPOSE_FILE" down --volumes --remove-orphans
    ;;
  refresh)
    echo "🔄 Rebuild + redémarrage (développement)"
    docker compose -f "$DOCKER_COMPOSE_FILE" down
    docker compose -f "$DOCKER_COMPOSE_FILE" up -d --build
    ;;
  restart)
    echo "🔄 Redémarrage (développement)"
    docker compose -f "$DOCKER_COMPOSE_FILE" restart
    ;;
  logs)
    echo "📜 Logs du conteneur messages-socket"
    docker logs -f messages-socket
    ;;
  npm)
    docker exec -it messages-socket npm "$@"
    ;;
  sh)
    docker exec -it messages-socket sh
    ;;
  *)
    echo "❌ Commande inconnue: $COMMAND"
    show_help
    exit 1
    ;;
esac
