import angular from 'angular';
import {DataService} from '../data-service';
/**
 * data service for project
 * @extends DataService
 */
export class ProjectDataService extends DataService {
    /**
     *
     * @returns {promise}
     */
    getServerProjects() {
        return new Promise((resolve, reject) => {
            this.get('project/loadMy').then(data => {
                if (data !== null && data !== undefined) {
                    resolve(data);
                }
                else {
                    reject();
                }
            });
        });
    }

    getProjects() {
        return new Promise((resolve) => {
            this.get('project/tree').catch(() => resolve([])).then(data => {
                if (data !== null && data !== undefined) {
                    resolve(data);
                }
                else {
                    resolve([]);
                }
            });
        });
    }

    getProjectsFilterVcfInfo(vcfFileIds) {
        return new Promise((resolve, reject) => {
            this.post('filter/info', vcfFileIds).then(data => {
                if (data !== null && data !== undefined) {
                    resolve(data);
                }
                else {
                    resolve(null);
                }
            });
        });
    }

    /**
     *
     * @param {number} projectId
     * @returns {promise}
     */
    getProject(projectId) {
        return this.get(`project/${projectId}/load`);
    }

    /**
     *
     * @param {number} referenceId
     * @param {string} featureId
     * @returns {promise}
     */
    searchGenes(referenceId, featureId) {
        return this.get(`reference/${referenceId}/search?featureId=${featureId}`);
    }

    /**
     *
     * @param {Project} project
     * @returns {promise}
     */
    saveProject(project) {
        return new Promise((resolve, reject) => {
            this.post('project/save', project).then((data) => {
                if (data) {
                    resolve(data);
                } else {
                    reject('ERROR on saving project');
                }
            });
        });
    }

    deleteProject(projectId) {
        return new Promise((resolve) => {
            this.delete(`project/${projectId}`).then((data) => {
                resolve(data);
            });
        });
    }

    getVcfVariationLoad(filter) {
        const {
            vcfFileIds,
            exon,
            chromosomeId,
            genes,
            variationTypes,
            additionalFilters,
            quality,
            infoFields
        }=filter;
        return new Promise((resolve, reject) => {
            this.post('filter', {
                chromosomeId, exon, vcfFileIds, genes, variationTypes, additionalFilters, quality, infoFields
            }).catch(()=>resolve([])).then((data) => {
                if (data) {
                    resolve(data);
                } else {
                    data = [];
                    resolve(data);
                }
            },reject);
        });
    }

    autocompleteGeneId(search, vcfIds) {
        return new Promise((resolve) => {
            this.post('filter/searchGenes', {search, vcfIds}).then((data) => {
                if (data) {
                    resolve(data);
                } else {
                    data = [];
                    resolve(data);
                }
            });
        });
    }
}