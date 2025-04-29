#!/bin/bash

DOCKER_COMPOSE_FILE="docker-compose.yml"

show_help() {
  echo "Commandes disponibles :"
  echo "  up                 → Démarrer tous les services (développement)"
  echo "  down               → Arrêter tous les services (développement)"
  echo "  destroy            → Supprimer complètement tous les conteneurs (développement)"
  echo "  refresh            → Redémarrer tous les services (développement)"
  echo "  restart            → Redémarrer tous les services (développement)"
  echo "  logs               → Afficher les logs"
}

if [ $# -lt 1 ]; then
  show_help
  exit 0
fi

COMMAND=$1
shift

case "$COMMAND" in
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
    echo "🔄 Redémarrage complet des services en développement"
    docker compose -f "$DOCKER_COMPOSE_FILE" down
    docker compose -f "$DOCKER_COMPOSE_FILE" up -d --build
    ;;
  restart)
    echo "🔄 Redémarrage des services en développement"
    docker compose -f "$DOCKER_COMPOSE_FILE" restart
    ;;
  logs)
    echo "📜 Logs du conteneur projet-4-php"
    docker logs -f projet-4-php
    ;;
  *)
    echo "❌ Commande inconnue: $COMMAND"
    show_help
    exit 1
    ;;
esac
