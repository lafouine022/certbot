#!/bin/bash
# //////////CERTBOT FOUINI/////////

# Adresse email pour les notifications Certbot
EMAIL="contact@easy-tk.biz"

# Installation de Certbot
echo ""
echo "Installation de Certbot..."
echo ""
apt-get install -y certbot python3-certbot-nginx

# Demander à l'utilisateur de saisir le nom de domaine
echo ""
echo "Veuillez entrer le nom de domaine pour le certificat (ex: s2.easy-tk.biz) :"
echo ""
read -r DOMAIN

# Vérifier si le domaine est vide
if [ -z "$DOMAIN" ]; then
    echo ""
    echo "Erreur : le nom de domaine ne peut pas être vide."
    echo ""
    exit 1
fi

# Exécuter Certbot pour obtenir le certificat sans modifier la configuration Nginx
certbot certonly --nginx -d "$DOMAIN" --non-interactive --agree-tos --email "$EMAIL"

# Chemin du fichier de configuration Nginx
NGINX_CONF="/etc/nginx/sites-enabled/rutorrent.conf"

# Remplacer les anciennes lignes de certificat par les nouvelles
sed -i "s|ssl_certificate /etc/nginx/ssl/server.crt;|ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;|g" "$NGINX_CONF"
sed -i "s|ssl_certificate_key /etc/nginx/ssl/server.key;|ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;|g" "$NGINX_CONF"

# Vérifier si la commande précédente a réussi
if [ $? -eq 0 ]; then
    echo ""
    echo "Certificat obtenu avec succès pour $DOMAIN."
    echo ""
    
    # Redémarrer Nginx pour appliquer les modifications
    systemctl restart nginx
    
    echo ""
    echo "FIN de l'installation d'EasyBOX ! Bienvenu sur: https://$DOMAIN/rutorrent"
    echo ""
else
    echo ""
    echo "Erreur lors de l'obtention du certificat pour $DOMAIN."
    echo ""
fi

# //////////FIN CERTBOT FOUINI/////////