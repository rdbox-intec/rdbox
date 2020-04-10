import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { HttpClient, HttpParams, HttpHeaders } from '@angular/common/http';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import * as _ from 'lodash';

import { EmptyDialogComponent } from '../empty-dialog/empty-dialog.component'
import { DeployStateDialogComponent } from '../deploy-state-dialog/deploy-state-dialog.component'


@Component({
  selector: 'app-bootstrap',
  templateUrl: './bootstrap.component.html',
  styleUrls: ['./bootstrap.component.scss']
})
export class BootstrapComponent implements OnInit {
  public bootstrapCustomForm: FormGroup;
  public projectArray: {[index: string]: string} = {};
  public regionZoneArray: {[index: string]: string[]} = {};
  public zoneArray: string[] = [];
  public machineTypeArray: {[index: string]: string} = {};
  public isDisableSubmit: boolean = false;
  public isCompleteDMCreate: boolean = false;
  public fontSize: string = '9px';
  public previewURL: string = 'https://console.cloud.google.com/dm/deployments'

  constructor(private formBuilder: FormBuilder,
              private http: HttpClient,
              public dialog: MatDialog) {}

  ngOnInit(): void {
    this.http.get('/api/bootstrap/gcp/projects'
    ).subscribe(
      json => {
        this.projectArray = <{[index: string]: string}>json;
        this.bootstrapCustomForm.controls.project.enable();
      },
      error => {
        alert('Response Error. Restart the service.')
      }
    );
    this.createForm();
  }

  private createForm(): void {
    this.bootstrapCustomForm = this.formBuilder.group({
      resourcesPrefix: ['', [
        Validators.required,
        Validators.pattern('^(([a-z0-9]|[a-z0-9][a-z0-9\-]*[a-z0-9])\.)*([a-z0-9]|[a-z0-9][a-z0-9\-]*[a-z0-9])$')
      ]],
      project: [{value:'', disabled: true}, [
        Validators.required
      ]],
      region: [{value:'', disabled: true}, [
        Validators.required
      ]],
      zone: [{value:'', disabled: true}, [
        Validators.required
      ]],
      yourGlobalIPAddress: ['', [
        Validators.required,
        Validators.pattern('(([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])')
      ]],
      adminPubKey: ['', [
        Validators.required,
        Validators.pattern('^ssh-rsa.*')
      ]],
      adminSecretKey: ['', [
        Validators.required
      ]],
      vpcCidrBlockAddress: ['172.16.0.0', [
        Validators.required,
        Validators.pattern('(([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])')
      ]],
      vpcCidrBlockSubnet: ['12', [
        Validators.required,
        Validators.min(1),
        Validators.max(32),
        Validators.pattern('[0-9]+')
      ]],
      osDiskType: ['pd-standard', [
        Validators.required
      ]],
      vmSizeVpnServer: ['n1-standard-1', [
        Validators.required
      ]],
      vmSizeKubeMaster: ['n1-standard-2', [
        Validators.required
      ]],
      osDiskSizeGBKubeMaster: [30, [
        Validators.required,
        Validators.min(1),
        Validators.max(1023),
        Validators.pattern('[0-9]+')
      ]],
      kubeNodeInstanceCount: [2, [
        Validators.required
      ]],
      vmSizeKubeNode: ['n1-standard-2', [
        Validators.required
      ]],
      osDiskSizeGBKubeNode: [40, [
        Validators.required,
        Validators.min(1),
        Validators.max(1023),
        Validators.pattern('[0-9]+')
      ]],
    });
  }

  public onChangeProject(newValue): void {
    this.openDisabledAllOperationDialog();
    this.http.get('/api/bootstrap/gcp/compute/zones', {
      params: new HttpParams().set('project', this.bootstrapCustomForm.value.project)
    }).subscribe(
      json => {
        this.dialog.closeAll();
        this.regionZoneArray = <{[index: string]: string[]}>json;
        this.bootstrapCustomForm.controls.region.enable();
      },
      error => {
        this.dialog.closeAll();
        alert('Response Error. Restart the service.')
      }
    );
  }

  public onChangeRegion(newValue): void {
    this.zoneArray = this.regionZoneArray[this.bootstrapCustomForm.value.region];
    this.bootstrapCustomForm.controls.zone.enable();
  }

  public onChangeZone(newValue): void {
    this.http.get('/api/bootstrap/gcp/compute/machine-types', {
      params: new HttpParams(
      ).set('project', this.bootstrapCustomForm.value.project)
      .set('zone', this.bootstrapCustomForm.value.zone)
    }).subscribe(
      json => {
        this.machineTypeArray = <{[index: string]: string}>json;
      },
      error => {
        alert('Response Error. Restart the service.')
      }
    );
  }

  public onSubmit(): void {
    this.isDisableSubmit = true;
    this.openDisabledAllOperationDialog();
    let postObj: Map<string, String> = this.objToMap(this.bootstrapCustomForm.value);
    let vpcCidrBlock: String = postObj.get('vpcCidrBlockAddress') + '/' + postObj.get('vpcCidrBlockSubnet')
    postObj.set('vpcCidrBlock', vpcCidrBlock);
    postObj.delete('vpcCidrBlockAddress');
    postObj.delete('vpcCidrBlockSubnet');
    this.http.post('/api/bootstrap/gcp/deployment-manager/deployments', this.mapToObj(postObj), {
      headers: new HttpHeaders({
        'Content-Type': 'application/json'
      })
    }).subscribe(
      json => {
        this.dialog.closeAll();
        this.openDeployStateDialog();
      },
      error => {
        if (error.status === 412) {
          this.isDisableSubmit = false;
          alert('Request failed (Error raise From GCP)')
          this.dialog.closeAll();
          console.log(error)
        } else if (error.status === 400) {
          this.isDisableSubmit = false;
          alert(error.error.msg)
          this.dialog.closeAll();
          console.log(error)
        } else {
          this.isDisableSubmit = false;
          alert('Request failed')
          this.dialog.closeAll();
          console.log(error)
        }
      }
    );
  }

  openDisabledAllOperationDialog(): void {
    this.dialog.open(EmptyDialogComponent, {
      width: '-1px',
      height: '-1px',
      disableClose : true
    });
  }

  openDeployStateDialog(): void {
    const dialogRef = this.dialog.open(DeployStateDialogComponent, {
      width: '450px',
      disableClose : true,
      data: {project: this.bootstrapCustomForm.value.project,
            deployment: this.bootstrapCustomForm.value.resourcesPrefix,
            state: 'START'}
    });
    dialogRef.afterClosed().subscribe(result => {
      if (result === 'SUCCESS') {
        this.previewURL = this.previewURL + '?' + 'project=' + this.bootstrapCustomForm.value.project;
        this.isCompleteDMCreate = true;
      } else if (result === 'ERROR') {
        this.isDisableSubmit = false;
      } else {
        alert('unexpected error!!');
        this.isDisableSubmit = false;
      }
    });
  }


  private mapToObj<V>(map: Map<string, V>): _.Dictionary<V>;
  private mapToObj<V>(map: Map<any, V>): _.Dictionary<V> {
      return _.fromPairs([...map]);
  }
  private objToMap<V>(obj: _.Dictionary<V>): Map<string, V>;
  private objToMap<V>(obj: _.Dictionary<V>): Map<any, V> {
      return new Map(Object.entries(obj));
  }


}
