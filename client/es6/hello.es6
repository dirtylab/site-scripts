// Constante
const githubUrl='http://github.com/dirtylab/site-scripts';
const bienvenue=`Bienvenue sur dirtybiology!
Tu es développeur et souhaite contribuer à l'élaboration du site?
Rejoins-nous ici : ${githubUrl} !`;

// Export du module avec une petite lambda
export default ()=> console.info(bienvenue);
